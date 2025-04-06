#!/usr/bin/env python3
"""Main Kaggle MCP server.

This module provides the base server configuration and handles imports of all tools.
"""

import os
import sys
from mcp.server.fastmcp import FastMCP

# Initialize the MCP server
mcp = FastMCP("Kaggle", description="Kaggle API integration through the Model Context Protocol")

# Import all tool modules to register them with the server
from kaggle_mcp.tools import (
    auth,
    competitions,
    datasets,
    kernels,
    models,
    config
)

def main():
    """Run the MCP server."""
    # Parse project configuration if needed
    # ... (placeholder for config logic)
    
    # Start the server
    mcp.run()
    
    return 0

if __name__ == "__main__":
    main()
