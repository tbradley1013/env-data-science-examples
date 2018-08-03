#OpenAQ - Global Air Pollution Measurements

This data set is an open source dataset that is provided from [OpenAQ](https://openaq.org/#/?_k=3519tj) and the data was retrieved using the [`aws.s3`](https://github.com/cloudyr/aws.s3) R package from [the AWS s3 bucket](https://openaq-fetches.s3.amazonaws.com/index.html). 

This dataset is a subset of the overall air quality data included in the AWS bucket, and includes all air quality results from within the United States of America during 2016. The dataset in this repo has been filtered to make the file size smaller for easier use and storage here. All relevant information should still be included, but if the full dataset is desired, it can be obtained by running the script `R/gaq-query-data/R`