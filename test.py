#!/usr/bin/env python3
"""Test script for the Kaggle MCP server."""

import importlib.util
import sys
import os

# Check if kaggle-mcp is installed
try:
    from kaggle_mcp.server import mcp
    print("✅ Kaggle MCP package is installed and importable")
except ImportError:
    print("❌ Kaggle MCP package not found. Please install it first with: pip install -e .")
    sys.exit(1)

# Check if kaggle is installed
try:
    import kaggle
    print("✅ Kaggle package is installed")
except ImportError:
    print("❌ Kaggle package not found. Please install it with: pip install kaggle")
    sys.exit(1)

# Check if mcp is installed
try:
    import mcp
    from mcp.server.fastmcp import FastMCP
    print("✅ MCP package is installed")
except ImportError:
    print("❌ MCP package not found. Please install it with: pip install mcp")
    sys.exit(1)

# Check Kaggle API credentials
kaggle_creds_path = os.path.expanduser("~/.kaggle/kaggle.json")
if os.path.exists(kaggle_creds_path):
    print(f"✅ Kaggle API credentials found at {kaggle_creds_path}")
else:
    print(f"⚠️ Kaggle API credentials not found at {kaggle_creds_path}")
    print("   You'll need to set up credentials before using the Kaggle tools.")
    print("   Visit https://www.kaggle.com/settings/account and click 'Create New API Token'")
    print("   Then save the downloaded kaggle.json file to ~/.kaggle/kaggle.json")
    print("   Make sure to run: chmod 600 ~/.kaggle/kaggle.json")

# Print available tools
print("\nAvailable MCP tools in Kaggle server:")
for tool_name, tool_handler in mcp.tool_handlers.items():
    print(f"- {tool_name}: {tool_handler.__doc__.split('.')[0] if tool_handler.__doc__ else 'No description'}")

print("\n✅ Test completed successfully. The Kaggle MCP server is ready to use.")
print("   To use with Claude Desktop, follow the installation instructions in README.md")
