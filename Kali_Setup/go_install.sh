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

#unfurl URL parser
go install github.com/tomnomnom/unfurl@latest

# wayback URLs finder
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/OJ/gobuster/v3@latest

# gau URLs finder
go install -v  github.com/lc/gau/v2/cmd/gau@latest

#chaos client
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest

#alterx subdomain mutator
go install github.com/projectdiscovery/alterx/cmd/alterx@latest

#project discovery tool manager
go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest


#cidr mapping
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

#asnmap
go install github.com/projectdiscovery/asnmap/cmd/asnmap@latest

#simple http server (allows tls!)
go install -v github.com/projectdiscovery/simplehttpserver/cmd/simplehttpserver@latest

