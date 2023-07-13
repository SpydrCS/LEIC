# Trabalho realizado na Semana #3

## Identificação

- Affected Zoom and its users;
- Path traversal issues that could ultimately lead to arbitrary code execution;

## Catalogação

- This exploit was discovered by a member of Cisco Talos;
- The CVSS score of the exploit is 6.8;
- The issue affected the versions 4.6.10, 4.6.11 and most likely previous versions;
- CWE - 22 : Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')

## Exploit

- When one user shares a code snippet with another, a zip file is created and uploaded to Zoom’s storage server via /zoomfile/upload request to file.zoom.us;
- The core of this vulnerability is that Zoom’s zip file extraction feature does not perform validation of the contents of the zip file before extracting it;
- This allows the attacker to plant an arbitrary binary without the user interaction;
- A partial path traversal issue allows the specially crafted zip file to write files outside the intended randomly generated directory.

## Attacks

- There were no reports of successfull malicious uses of the exploit as it was discovered by Cisco Talo;
- The vulnerability was reported to the vendor and fixed a couple of updates later.

