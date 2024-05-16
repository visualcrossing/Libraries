from setuptools import setup, find_packages

setup(
    name='weather',
    version='0.1.0',
    packages=find_packages(),
    description='A efficient and easy-to-use weather data fetching from weather API and processing package',
    author='VisualCrossing team',
    # author_email='your.email@example.com',
    url='https://github.com/yourusername/my_package',
    install_requires=[
        'requests',  # Ensure you list all necessary packages here
    ],
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)
