# Delete all tags & releases
gh release list | awk -F '\\t' '{print $3}' | while read -r line; do gh release delete -y "$line" --cleanup-tag; done