import os
import sys
try:
    from setuptools import setup, find_packages
except ImportError:
    from distutils.core import setup , find_packages




setup(name='MoA',
      version='0.1',
      description='Tools for testing a network',
      urls='https://github.com/Security-Banana-Group/MoA',
      author='EVT RIT',
      author_email='peaches@RIT.EDU',
      packages=find_packages(),
      scripts= [],
      license='MIT',
      include_package_data=False,
      package_data={ '': ['*.txt', '*.rst']},
      zip_safe=False,
      entry_points ={
      'console_scripts': [
                  'pytrace = moa.trace.exec:run_trace'
              ],
      })


BIN_PATH = '/usr/local/bin'
