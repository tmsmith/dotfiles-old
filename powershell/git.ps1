function g 
{
  git $args
}

function _git_status 
{
  git status -sb 
}

Set-Alias gs _git_status
