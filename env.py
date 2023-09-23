import os
 
# printing environment variables
# for k, v in os.environ.items():
#    print(f'{k}={v}')

name =os.environ['MY_NAME']
surname = os.environ['MY_SURNAME']
print(f'{name} home directory is {surname}')
