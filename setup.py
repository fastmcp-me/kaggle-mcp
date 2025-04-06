"""Setup script for Kaggle MCP."""

from setuptools import setup, find_packages

setup(
    name="kaggle-mcp",
    version="0.1.0",
    description="MCP server for Kaggle API integration",
    author="Kaggle MCP Contributors",
    packages=find_packages(),
    install_requires=[
        "mcp>=1.2.0",
        "kaggle>=1.5.0",
    ],
    entry_points={
        "console_scripts": [
            "kaggle-mcp=kaggle_mcp.server:run",
        ],
    },
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
    ],
    python_requires=">=3.8",
)
