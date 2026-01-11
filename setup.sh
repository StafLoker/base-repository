#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL for raw files
BASE_URL="https://raw.githubusercontent.com/StafLoker/base-repository/main"

# Array to track downloaded files for git add
DOWNLOADED_FILES=()

# Print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Merge content into existing file under ## Project ## section
merge_file_content() {
    local existing_file="$1"
    local temp_file="$2"

    # Save existing content
    local existing_backup="${existing_file}.backup"
    cp "$existing_file" "$existing_backup"

    # Copy new file and append existing content at the end
    cp "$temp_file" "$existing_file"
    echo "" >> "$existing_file"
    echo "#############" >> "$existing_file"
    echo "## Project ##" >> "$existing_file"
    echo "#############" >> "$existing_file"
    echo "" >> "$existing_file"
    cat "$existing_backup" >> "$existing_file"

    rm -f "$temp_file"
    rm -f "$existing_backup"
    print_success "Merged existing content into: $existing_file"
}

# Download file from repository
download_file() {
    local file_path="$1"
    local dest_path="$2"
    local url="${BASE_URL}/${file_path}"
    local temp_dest="${dest_path}.download_temp"

    # Download to temporary file first
    if curl -fsSL "$url" -o "$temp_dest" 2>/dev/null; then
        # Check if file already exists
        if [ -f "$dest_path" ]; then
            echo ""
            print_warning "File already exists: $dest_path"
            echo ""
            echo "What would you like to do?"
            echo "  1) Replace - Delete existing file and use new one"
            echo "  2) Merge   - Add new content first, then existing content under ## Project ## section"
            echo "  3) Skip    - Keep existing file, don't download"
            echo ""

            while true; do
                read -p "$(echo -e "${BLUE}?${NC} Enter your choice [1-3]: ")" file_choice
                case $file_choice in
                    1)
                        mv "$temp_dest" "$dest_path"
                        print_success "Replaced: $dest_path"
                        DOWNLOADED_FILES+=("$dest_path")
                        return 0
                        ;;
                    2)
                        merge_file_content "$dest_path" "$temp_dest"
                        DOWNLOADED_FILES+=("$dest_path")
                        return 0
                        ;;
                    3)
                        rm -f "$temp_dest"
                        print_info "Skipped: $dest_path"
                        return 0
                        ;;
                    *)
                        print_warning "Please enter 1, 2, or 3."
                        ;;
                esac
            done
        else
            # File doesn't exist, just move it
            mv "$temp_dest" "$dest_path"
            print_success "Downloaded: $dest_path"
            DOWNLOADED_FILES+=("$dest_path")
            return 0
        fi
    else
        print_error "Failed to download: $file_path"
        rm -f "$temp_dest"
        return 1
    fi
}

# Create directory if it doesn't exist
ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_info "Created directory: $1"
    fi
}

# Ask yes/no question
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local prompt

    if [ "$default" = "y" ]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi

    while true; do
        read -p "$(echo -e "${BLUE}?${NC} $question $prompt: ")" answer
        answer=${answer:-$default}
        case ${answer:0:1} in
            y|Y) return 0 ;;
            n|N) return 1 ;;
            *) print_warning "Please answer yes or no." ;;
        esac
    done
}

# Download git configuration files
setup_git() {
    print_info "Setting up Git configuration..."
    download_file "git/.gitignore" ".gitignore"
    download_file "git/.gitattributes" ".gitattributes"
}

# Download editor configuration
setup_editor() {
    print_info "Setting up editor configuration..."
    download_file "editor/.editorconfig" ".editorconfig"
}

# Get list of available licenses from repository
get_available_licenses() {
    local licenses_url="${BASE_URL}/licenses/"
    local available_licenses=()

    # Try to fetch license files list
    # For now, we know MIT exists. In future, could parse directory listing
    available_licenses=("MIT")

    echo "${available_licenses[@]}"
}

# Download license
setup_license() {
    echo ""
    print_info "Available licenses:"
    echo ""

    # Get available licenses
    local licenses=($(get_available_licenses))

    # Show menu
    local i=1
    for license in "${licenses[@]}"; do
        echo "  $i) $license"
        ((i++))
    done
    echo "  0) Skip - Don't add a license"
    echo ""

    while true; do
        read -p "$(echo -e "${BLUE}?${NC} Select a license [0-${#licenses[@]}]: ")" license_choice

        if [ "$license_choice" = "0" ]; then
            print_info "Skipping license"
            return 0
        elif [ "$license_choice" -ge 1 ] && [ "$license_choice" -le "${#licenses[@]}" ]; then
            local selected_license="${licenses[$((license_choice-1))]}"
            print_info "Selected: $selected_license"

            download_file "licenses/$selected_license" "LICENSE"

            # Check if download was successful
            if [ -f "LICENSE" ]; then
                # Ask for name and year
                read -p "$(echo -e "${BLUE}?${NC} Your name or organization: ")" name
                read -p "$(echo -e "${BLUE}?${NC} Year (default: $(date +%Y)): ")" year
                year=${year:-$(date +%Y)}

                # Replace placeholders in LICENSE
                sed -i.bak "s/<year>/$year/g" "LICENSE" 2>/dev/null || sed -i "" "s/<year>/$year/g" "LICENSE"
                sed -i.bak "s/<name>/$name/g" "LICENSE" 2>/dev/null || sed -i "" "s/<name>/$name/g" "LICENSE"
                rm -f "LICENSE.bak"
                print_success "License configured with $name ($year)"
            fi
            return 0
        else
            print_warning "Please enter a number between 0 and ${#licenses[@]}"
        fi
    done
}

# Get list of available README templates from repository
get_available_readmes() {
    local readmes_url="${BASE_URL}/readmes/"
    local available_readmes=()

    # Available README templates
    available_readmes=("opensource-project")

    echo "${available_readmes[@]}"
}

# Download README template
setup_readme() {
    echo ""
    print_info "Available README templates:"
    echo ""

    # Get available READMEs
    local readmes=($(get_available_readmes))

    # Show menu
    local i=1
    for readme in "${readmes[@]}"; do
        echo "  $i) $readme"
        ((i++))
    done
    echo "  0) Skip - Don't add a README"
    echo ""

    while true; do
        read -p "$(echo -e "${BLUE}?${NC} Select a README template [0-${#readmes[@]}]: ")" readme_choice

        if [ "$readme_choice" = "0" ]; then
            print_info "Skipping README"
            return 0
        elif [ "$readme_choice" -ge 1 ] && [ "$readme_choice" -le "${#readmes[@]}" ]; then
            local selected_readme="${readmes[$((readme_choice-1))]}"
            print_info "Selected: $selected_readme"

            download_file "readmes/$selected_readme.md" "README.md"

            # Check if download was successful
            if [ -f "README.md" ]; then
                print_warning "Don't forget to customize README.md with your project information!"
            fi
            return 0
        else
            print_warning "Please enter a number between 0 and ${#readmes[@]}"
        fi
    done
}

# Initialize git repository and commit
setup_git_repo() {
    # Check if there are any downloaded files to commit
    if [ ${#DOWNLOADED_FILES[@]} -eq 0 ]; then
        print_info "No files were downloaded, skipping git operations"
        return 0
    fi

    if [ ! -d ".git" ]; then
        if ask_yes_no "Initialize git repository?" "y"; then
            git init
            print_success "Git repository initialized"

            if ask_yes_no "Commit downloaded files?" "y"; then
                # Add only downloaded files
                for file in "${DOWNLOADED_FILES[@]}"; do
                    git add "$file"
                done

                git commit -m "Initial commit"
                print_success "Initial commit created (${#DOWNLOADED_FILES[@]} files)"
            fi
        fi
    else
        print_info "Git repository already exists"
        if ask_yes_no "Commit downloaded files?" "y"; then
            # Add only downloaded files
            for file in "${DOWNLOADED_FILES[@]}"; do
                git add "$file"
            done

            git commit -m "Add base configuration files

Files added via base-repository setup script:
$(printf '- %s\n' "${DOWNLOADED_FILES[@]}")"
            print_success "Files committed (${#DOWNLOADED_FILES[@]} files)"
        fi
    fi
}

# Template: Basic (Git + Editor)
template_basic() {
    echo ""
    print_info "Installing Basic Template..."
    echo "  • Git configuration (.gitignore, .gitattributes)"
    echo "  • Editor configuration (.editorconfig)"
    echo ""

    setup_git
    setup_editor
}

# Template: Standard (Git + Editor + License)
template_standard() {
    echo ""
    print_info "Installing Standard Template..."
    echo "  • Git configuration (.gitignore, .gitattributes)"
    echo "  • Editor configuration (.editorconfig)"
    echo "  • License"
    echo ""

    setup_git
    setup_editor
    setup_license
}

# Template: Full Open Source (Git + Editor + License + README)
template_full() {
    echo ""
    print_info "Installing Full Open Source Template..."
    echo "  • Git configuration (.gitignore, .gitattributes)"
    echo "  • Editor configuration (.editorconfig)"
    echo "  • License"
    echo "  • README"
    echo ""

    setup_git
    setup_editor
    setup_license
    setup_readme
}

# Custom template - ask for each component
template_custom() {
    echo ""
    print_info "Custom Template - Choose components:"
    echo ""

    if ask_yes_no "Include Git configuration?" "y"; then
        setup_git
    fi

    if ask_yes_no "Include Editor configuration?" "y"; then
        setup_editor
    fi

    setup_license
    setup_readme
}

# Main menu
show_menu() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        Base Repository Setup Script        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Select a template to install:"
    echo ""
    echo "  1) Basic              - Git + Editor"
    echo "  2) Standard           - Git + Editor + License"
    echo "  3) Full Open Source   - Git + Editor + License + README"
    echo "  4) Custom             - Choose components"
    echo ""
    echo "  0) Exit"
    echo ""
}

# Main script
main() {
    # Check if we're in a directory
    if [ ! -w "." ]; then
        print_error "Cannot write to current directory"
        exit 1
    fi

    # Check for curl
    if ! command -v curl &> /dev/null; then
        print_error "curl is required but not installed"
        exit 1
    fi

    # Check for git
    if ! command -v git &> /dev/null; then
        print_warning "git is not installed - repository initialization will be skipped"
    fi

    # Show current directory
    print_info "Current directory: $(pwd)"
    echo ""

    # If argument provided, use it as template choice
    if [ $# -eq 1 ]; then
        choice="$1"
    else
        show_menu
        read -p "$(echo -e "${BLUE}?${NC} Enter your choice: ")" choice
    fi

    case $choice in
        1)
            template_basic
            ;;
        2)
            template_standard
            ;;
        3)
            template_full
            ;;
        4)
            template_custom
            ;;
        0)
            print_info "Setup cancelled"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac

    echo ""

    # Offer to initialize/commit to git
    if command -v git &> /dev/null; then
        setup_git_repo
    fi

    echo ""
    print_success "Setup complete!"
    echo ""
    print_info "Next steps:"
    echo "  • Review and customize the downloaded files"
    if [ -f "README.md" ]; then
        echo "  • Update README.md with your project information"
    fi
    if [ -f "LICENSE" ]; then
        echo "  • Verify LICENSE information is correct"
    fi
    echo ""
}

# Run main function
main "$@"
