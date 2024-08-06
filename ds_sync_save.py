import os
import time
import shutil
import json
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

class SaveFileHandler(FileSystemEventHandler):
    def __init__(self):
        self.last_synced = {}

    def on_modified(self, event):
        if not event.is_directory:
            self.sync_save_files(event.src_path)

    def sync_save_files(self, path):
        directory, filename = os.path.split(path)
        name, ext = os.path.splitext(filename)
        if ext in ['.dsv', '.sav']:
            other_ext = '.sav' if ext == '.dsv' else '.dsv'
            other_path = os.path.join(directory, name + other_ext)
            
            current_time = time.time()
            if path in self.last_synced and current_time - self.last_synced[path] < 1:
                return

            shutil.copy2(path, other_path)
            logging.info(f"Updated {other_path} from {path}")

            self.last_synced[path] = current_time
            self.last_synced[other_path] = current_time

def load_config(config_path):
    with open(config_path, 'r') as config_file:
        return json.load(config_file)

if __name__ == "__main__":
    config_path = "config.json"
    config = load_config(config_path)

    observers = []
    for folder in config['watched_folders']:
        logging.info(f"Watching for changes in {folder}")
        event_handler = SaveFileHandler()
        observer = Observer()
        observer.schedule(event_handler, folder, recursive=False)
        observer.start()
        observers.append(observer)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        for observer in observers:
            observer.stop()
    
    for observer in observers:
        observer.join()
