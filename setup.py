from setuptools import setup, find_packages

setup(
    version='0.3',
    name='qgis2to3',
    packages=find_packages(exclude=['tests*']),
    scripts=[
        'qgis2to3/api2finder/qgis2apifinder',
        'qgis2to3/2to3/qgis2to3'
        ],
    url='https://github.com/opengisch/qgis2to3',
    # download_url='https://github.com/opengisch/qgis2to3/archive/0.1.tar.gz',
    license='GPLv3',
    author='Marco Bernasocchi',
    author_email='marco@opengis.ch',
    description='Tools to help porting QGIS Plugins from api v2 to api v3',
    keywords=[
        'qgis',
        '2to3',
        'porting'
        ],
    classifiers=[
        'Topic :: Database',
        'License :: OSI Approved :: GNU General Public License v3 or later ('
        'GPLv3+)',
        'Intended Audience :: Developers',
        'Intended Audience :: Information Technology',
        'Topic :: Software Development',
        'Topic :: Software Development :: Bug Tracking',
        'Development Status :: 4 - Beta'
        ],
    # install_requires=[],
    python_requires='~=3.3',
    )
