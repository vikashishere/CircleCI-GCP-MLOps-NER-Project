# # Demo on downloading data from gcloud storage

# from ner.configuration.gcloud import GCloud

# obj = GCloud()
# obj.sync_folder_from_gcloud(gcp_bucket_url="ner-using-bert-vikash", filename="archive.zip", destination="gcp_download")

# -------------------------------------------------------------------------------------------------------------------------

# Demo on Data Ingestion Component

import os, sys
from ner.exception import NerException
from ner.pipeline.train_pipeline import TrainPipeline
from ner.constants import *

def training():
    try:
        train_pipeline = TrainPipeline()
        train_pipeline.run_pipeline()
    except Exception as e:
        raise NerException(e, sys) from e
    
if __name__=="__main__":
    training()