from pkg_resources import load_entry_point

ENTRY_GROUP = 'setuptools_scm.parse_scm'
ENTRY_NAME = '.git_archival.txt'

dist = 'setuptools_scm_git_archive'
load_entry_point(dist, ENTRY_GROUP, ENTRY_NAME)
