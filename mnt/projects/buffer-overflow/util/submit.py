#!/usr/bin/env python3
from getpass import getpass
from time import sleep
import sys
import requests
import warnings

SITE='hamsa.cs.northwestern.edu'
LOGIN='https://hamsa.cs.northwestern.edu/login/'

def submit(project, file):
  username = input('Username: ')
  password = getpass('Password: ')

  payload = {'username': username, 'password': password}
  session = requests.Session()
  session.post(LOGIN, data=payload, verify=False)
  url = 'http://%s/projects/%i/submit/' % (SITE, project)
  files = {'file': open(file, 'rb')}
  response = session.post(url, files=files, verify=False)
  try:
    submission = int(response.text)
  except ValueError:
    sys.stderr.write('Invalid username and password\n')
    sys.exit(1)
    
  started = False
  count = -1
  while True:
    response = session.get('http://%s/projects/status/%i/' % (SITE, submission))
    status = int(response.text)
    if status == 0: break
    elif status == 1:
      if not started:
        started = True
        if count > 0: sys.stderr.write('\n')
        sys.stderr.write('Testing started')
    elif count <= 0:
      if count == 0: sys.stderr.write('\n')
      sys.stderr.write('At position %i in queue' % (status-1))
      count = 10
    count -= 1
    sys.stderr.write('.')
    sleep(1)

  sys.stderr.write('\n')

  response = session.get('http://%s/projects/result/%i/' % (SITE, submission))
  print(response.text)

if __name__ == '__main__':
  warnings.simplefilter("ignore")
  submit(int(sys.argv[1]), sys.argv[2])
