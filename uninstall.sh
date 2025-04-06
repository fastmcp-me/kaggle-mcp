uninstall -y kaggle-mcp
elif command_exists pip; then
  warn "Using pip instead of uv"
  pip uninstall -y kaggle-mcp
else
  error "Neither uv nor pip found. Cannot uninstall Kaggle-MCP."
fi

success "Kaggle-MCP uninstalled successfully!"

# Check for Claude Desktop config
check_claude_config() {
  config_found=0
  
  # Check common locations for Claude Desktop config
  for config_path in \
    "$HOME/Library/Application Support/Claude/claude_desktop_config.json" \
    "$HOME/Library/Application Support/Claude/config/claude_desktop_config.json" \
    "$HOME/.config/Claude/config/claude_desktop_config.json" \
    "$APPDATA/Claude/config/claude_desktop_config.json"
  do
    if [ -f "$config_path" ]; then
      config_found=1
      warn "Claude Desktop configuration found at: $config_path"
      echo "You may want to manually remove the 'kaggle' entry from the mcpServers section."
      echo "Example of what to remove:"
      echo '    "mcpServers": {'
      echo '        "kaggle": {'
      echo '            "command": "kaggle-mcp"'
      echo '        }'
      echo '    }'
      break
    fi
  done
  
  if [ "$config_found" -eq 0 ]; then
    info "Claude Desktop configuration not found."
  fi
}

check_claude_config

# Mention Kaggle credentials
info "Note about Kaggle credentials:"
echo "Your Kaggle API credentials at ~/.kaggle/kaggle.json were not modified."
echo "If you no longer need them, you can remove them manually."

echo
success "Uninstallation complete!"
