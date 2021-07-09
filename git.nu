def git-body [sha:string] {
    git log --format=format:%b -1 $sha
}

def git-log  [--branch (-b) : string, --full] {
    let raw = (git log --format='%h@!@%an@!@%ae@!@%ad@!@%s' $branch | lines | parse '{sha}@!@{name}@!@{email}@!@{date}@!@{subject}')
    let with-date = ($raw | update date { get date | str to-datetime })
    let do_expensive = (echo $full | empty?)
    if $do_expensive { echo $with-date } { echo $with-date | insert body { get sha | each { git-body $it}} }
}

alias gl = git-log
