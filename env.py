import os
 
# printing environment variables
for k, v in os.environ.items():
    print(f'{k}={v}')
