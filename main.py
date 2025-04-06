#!/usr/bin/env python3
"""
Kaggle-MCP: Kaggle API Integration for Claude AI

Main entry point for the kaggle-mcp package.
"""

import argparse
import logging
import os
import signal
import sys
from typing import List

from kaggle_mcp.server import main as server_main


def parse_arguments(args: List[str]) -> argparse.Namespace:
    """Parse command line arguments for the Kaggle MCP server.
    
    Args:
        args: Command line arguments
        
    Returns:
        Parsed arguments
    """
    parser = argparse.ArgumentParser(
        description="Kaggle MCP: Kaggle API integration through the Model Context Protocol"
    )
    
    parser.add_argument(
        "--debug", 
        action="store_true", 
        help="Enable debug logging"
    )
    
    parser.add_argument(
        "--transport", 
        choices=["stdio", "sse"], 
        default="stdio",
        help="Transport mechanism to use (default: stdio)"
    )
    
    parser.add_argument(
        "--host", 
        default="localhost",
        help="Host to bind to when using SSE transport (default: localhost)"
    )
    
    parser.add_argument(
        "--port", 
        type=int, 
        default=3000,
        help="Port to bind to when using SSE transport (default: 3000)"
    )
    
    parser.add_argument(
        "--config", 
        help="Path to configuration file"
    )
    
    return parser.parse_args(args)


def setup_logging(debug: bool) -> None:
    """Configure logging based on debug flag.
    
    Args:
        debug: Whether to enable debug logging
    """
    log_level = logging.DEBUG if debug else logging.INFO
    logging.basicConfig(
        level=log_level,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )


def setup_signal_handlers() -> None:
    """Set up signal handlers for graceful shutdown."""
    def handle_signal(sig, frame):
        logging.info("Received signal %s, shutting down...", sig)
        sys.exit(0)
    
    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)


def main() -> int:
    """Entry point for the kaggle-mcp package.
    
    Returns:
        Exit code
    """
    args = parse_arguments(sys.argv[1:])
    setup_logging(args.debug)
    setup_signal_handlers()
    
    logging.info("Starting Kaggle MCP server")
    
    try:
        # Pass arguments to server_main
        return server_main(
            transport=args.transport,
            host=args.host,
            port=args.port,
            config_path=args.config,
            debug=args.debug
        )
    except KeyboardInterrupt:
        logging.info("Interrupted, shutting down...")
        return 0
    except Exception as e:
        logging.error("Error running Kaggle MCP server: %s", str(e), exc_info=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
