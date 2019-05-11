# gcluster-core

Go core code to create gatling-cluster in kubernetes

export GO111MODULE=on
go get k8s.io/client-go@v8.0.0
go get k8s.io/api@kubernetes-1.11.0
go get k8s.io/apimachinery@kubernetes-1.11.0

go build main.go
