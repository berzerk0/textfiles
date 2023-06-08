
#dnsx for dns-ing
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

#subfinder for finding subdomains
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

#nuclei "vuln scanner" and so much more
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

#httpx - http toolkit
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

#katana spiderer/crawler
go install github.com/projectdiscovery/katana/cmd/katana@latest

#naabu portscanner
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest


# wayback URLs finder
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/OJ/gobuster/v3@latest


# gau URLs finder
go install -v  github.com/lc/gau/v2/cmd/gau@latest
