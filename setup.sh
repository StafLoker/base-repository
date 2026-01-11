#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL for raw files
BASE_URL="https://raw.githubusercontent.com/StafLoker/base-repository/main"

# Print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Download file from repository
download_file() {
    local file_path="$1"
    local dest_path="$2"
    local url="${BASE_URL}/${file_path}"

    if curl -fsSL "$url" -o "$dest_path" 2>/dev/null; then
        print_success "Downloaded: $dest_path"
        return 0
    else
        print_error "Failed to download: $file_path"
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

# Download MIT license
setup_license() {
    if ask_yes_no "Do you want to add MIT License?" "y"; then
        download_file "licenses/MIT" "LICENSE"

        # Ask for name and year
        read -p "$(echo -e "${BLUE}?${NC} Your name or organization: ")" name
        read -p "$(echo -e "${BLUE}?${NC} Year (default: $(date +%Y)): ")" year
        year=${year:-$(date +%Y)}

        # Replace placeholders in LICENSE
        if [ -f "LICENSE" ]; then
            sed -i.bak "s/<year>/$year/g" "LICENSE" 2>/dev/null || sed -i "" "s/<year>/$year/g" "LICENSE"
            sed -i.bak "s/<name>/$name/g" "LICENSE" 2>/dev/null || sed -i "" "s/<name>/$name/g" "LICENSE"
            rm -f "LICENSE.bak"
            print_success "License configured with $name ($year)"
        fi
    fi
}

# Download README template
setup_readme() {
    if ask_yes_no "Do you want to add README template?" "y"; then
        download_file "readmes/opensource-project.md" "README.md"
        print_warning "Don't forget to customize README.md with your project information!"
    fi
}

# Initialize git repository and commit
setup_git_repo() {
    if [ ! -d ".git" ]; then
        if ask_yes_no "Initialize git repository?" "y"; then
            git init
            print_success "Git repository initialized"

            if ask_yes_no "Commit all downloaded files?" "y"; then
                git add .
                git commit -m "Initial commit: project setup

Files added:
- Git configuration (.gitignore, .gitattributes)
- Editor configuration (.editorconfig)
- License and README templates

Generated with base-repository setup script"
                print_success "Initial commit created"
            fi
        fi
    else
        print_info "Git repository already exists"
        if ask_yes_no "Commit downloaded files?" "y"; then
            git add .
            git commit -m "Add base configuration files

Files added via base-repository setup script"
            print_success "Files committed"
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
    echo "  • MIT License"
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
    echo "  • MIT License"
    echo "  • Open Source README template"
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
    echo -e "${GREEN}║     Base Repository Setup Script          ║${NC}"
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
