## Job Template


Usage: 
Machines, mediums, test suites and job templates can all set various configuration variables. The so called job templates within the job groups define how the test suites, mediums and machines should be combined in various ways to produce individual 'jobs'

Refer to https://open.qa/docs/#_using_job_templates_to_automate_jobs_creation 

1. We place template files in /var/lib/openqa/tests/opensuse/products/opensuse

2. Still we can also load job template from any location 

3. Example to load template file for Harvester

    ```
    In template folder
    $ ./templates-harvester --apikey <api-key> --apisecret <api-secret> 
    ``` 