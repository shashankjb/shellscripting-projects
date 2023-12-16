#!/bin/bash

#####################################
# Author: shashank biradar          #
# Email: shashankjb3@gmail.com      #
# Date: 16/12/2023                  #
#####################################

#Debug mode is on#
set -x

#GitHub API URL
api_url= "https://api.github.com"

# Github username and token
USERNAME= $username 
TOKEN= $token 

#User and repository information
REPO_OWNER= $1
REPO_NAME= $2

#Function to make a GET request to the github API
function github_api_get {
    local endpoint="$1"
    local url="${api_url}/${endpoint}"
    
    # send a GET request to the Github API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    
    #Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')" 
    
    #display the list of collaborators with read acess
    if [[ -z "$collaborators" ]]; then
           echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
           echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
           echo "$collaborators"       
    fi
}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access