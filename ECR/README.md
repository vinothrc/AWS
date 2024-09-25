## Shell script to save ECR scan report in JSON format

#### Set your AWS credentials and token

```bash
export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
```
#### Set your AWS Region

```bash
REGION="us-west-2"
```

#### Replace reponamespace/ with your repo name

```bash
'example-namespace/'
```

After updating the above parameters, you can execute the shell script.

The JSON files will be stored in scan_results/reponamespace/sha_*name.json

