# webrix-postgres

An in-house Helm chart for deploying PostgreSQL using the **official [`postgres` Docker image](https://hub.docker.com/_/postgres)**.

## TL;DR

```bash
helm install my-postgresql .
```

## Introduction

This chart bootstraps a [PostgreSQL](https://www.postgresql.org/) StatefulSet on [Kubernetes](https://kubernetes.io/) using the official `postgres` Docker image.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8+
- PV provisioner support in the underlying infrastructure (for persistence)

## Installing the Chart

```bash
helm install my-postgresql . \
  --set auth.postgresPassword=secretpassword \
  --set auth.username=myuser \
  --set auth.password=myuserpassword \
  --set auth.database=mydb
```

## Uninstalling the Chart

```bash
helm delete my-postgresql
```

> **Note**: The PersistentVolumeClaim created by the chart is **not** deleted when the chart is uninstalled.

## Parameters

### Global parameters

| Key | Description | Default |
|-----|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `""` |
| `global.imagePullSecrets` | Global Docker registry pull secrets | `[]` |
| `global.defaultStorageClass` | Global default StorageClass | `""` |

### Common parameters

| Key | Description | Default |
|-----|-------------|---------|
| `nameOverride` | Partial chart name override | `""` |
| `fullnameOverride` | Full chart name override | `""` |
| `clusterDomain` | Kubernetes cluster domain | `cluster.local` |
| `commonLabels` | Labels added to all objects | `{}` |
| `commonAnnotations` | Annotations added to all objects | `{}` |

### Image parameters

| Key | Description | Default |
|-----|-------------|---------|
| `image.registry` | Image registry | `docker.io` |
| `image.repository` | Image repository | `postgres` |
| `image.tag` | Image tag | `17.4` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.pullSecrets` | Image pull secrets | `[]` |

### Authentication parameters

| Key | Description | Default |
|-----|-------------|---------|
| `auth.enablePostgresUser` | Enable password for the `postgres` admin user | `true` |
| `auth.postgresPassword` | Password for the `postgres` admin user | `""` |
| `auth.username` | Name for a custom user to create | `""` |
| `auth.password` | Password for the custom user | `""` |
| `auth.database` | Name for a custom database to create | `""` |
| `auth.existingSecret` | Use an existing secret for credentials | `""` |
| `auth.secretKeys.adminPasswordKey` | Key in existing secret for admin password | `postgres-password` |
| `auth.secretKeys.userPasswordKey` | Key in existing secret for user password | `password` |

### Primary StatefulSet parameters

| Key | Description | Default |
|-----|-------------|---------|
| `primary.configuration` | PostgreSQL `postgresql.conf` content | `""` |
| `primary.pgHbaConfiguration` | PostgreSQL `pg_hba.conf` content | `""` |
| `primary.extendedConfiguration` | Extra config appended to `postgresql.conf` | `""` |
| `primary.existingConfigmap` | Use an existing ConfigMap for configuration | `""` |
| `primary.initdb.scripts` | Dictionary of init scripts to run on first boot | `{}` |
| `primary.initdb.scriptsConfigMap` | ConfigMap with init scripts (overrides `initdb.scripts`) | `""` |
| `primary.extraEnvVars` | Extra environment variables | `[]` |
| `primary.extraEnvVarsCM` | ConfigMap with extra env vars | `""` |
| `primary.extraEnvVarsSecret` | Secret with extra env vars | `""` |
| `primary.resources.requests.cpu` | CPU request | `250m` |
| `primary.resources.requests.memory` | Memory request | `256Mi` |
| `primary.resources.limits.cpu` | CPU limit | `1` |
| `primary.resources.limits.memory` | Memory limit | `512Mi` |
| `primary.nodeSelector` | Node selector | `{}` |
| `primary.tolerations` | Tolerations | `[]` |
| `primary.affinity` | Affinity | `{}` |
| `primary.podAnnotations` | Pod annotations | `{}` |
| `primary.podLabels` | Extra pod labels | `{}` |
| `primary.podSecurityContext.enabled` | Enable pod security context | `true` |
| `primary.podSecurityContext.fsGroup` | fsGroup | `999` |
| `primary.containerSecurityContext.enabled` | Enable container security context | `true` |
| `primary.containerSecurityContext.runAsUser` | runAsUser | `999` |
| `primary.containerSecurityContext.runAsNonRoot` | runAsNonRoot | `true` |
| `primary.containerSecurityContext.allowPrivilegeEscalation` | allowPrivilegeEscalation | `false` |
| `primary.livenessProbe.enabled` | Enable liveness probe | `true` |
| `primary.readinessProbe.enabled` | Enable readiness probe | `true` |
| `primary.startupProbe.enabled` | Enable startup probe | `false` |
| `primary.updateStrategy.type` | Update strategy | `RollingUpdate` |
| `primary.extraVolumes` | Extra volumes | `[]` |
| `primary.extraVolumeMounts` | Extra volume mounts | `[]` |
| `primary.sidecars` | Sidecar containers | `[]` |
| `primary.initContainers` | Extra init containers | `[]` |

### Persistence parameters

| Key | Description | Default |
|-----|-------------|---------|
| `primary.persistence.enabled` | Enable persistence using PVC | `true` |
| `primary.persistence.storageClass` | PVC storage class | `""` |
| `primary.persistence.accessModes` | PVC access modes | `[ReadWriteOnce]` |
| `primary.persistence.size` | PVC storage size | `8Gi` |
| `primary.persistence.annotations` | PVC annotations | `{}` |
| `primary.persistence.existingClaim` | Use an existing PVC | `""` |
| `primary.persistence.mountPath` | Data volume mount path | `/var/lib/postgresql/data` |
| `primary.persistence.subPath` | Subdirectory within the volume | `pgdata` |

### Service parameters

| Key | Description | Default |
|-----|-------------|---------|
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.ports.postgresql` | PostgreSQL service port | `5432` |
| `service.nodePorts.postgresql` | Node port (when type=NodePort) | `""` |
| `service.annotations` | Service annotations | `{}` |
| `service.loadBalancerIP` | LoadBalancer IP | `""` |
| `service.loadBalancerSourceRanges` | LoadBalancer source ranges | `[]` |
| `service.clusterIP` | Cluster IP | `""` |

### ServiceAccount parameters

| Key | Description | Default |
|-----|-------------|---------|
| `serviceAccount.create` | Create a ServiceAccount | `false` |
| `serviceAccount.name` | ServiceAccount name | `""` |
| `serviceAccount.automountServiceAccountToken` | Automount service account token | `false` |
| `serviceAccount.annotations` | ServiceAccount annotations | `{}` |

### Volume permissions parameters

| Key | Description | Default |
|-----|-------------|---------|
| `volumePermissions.enabled` | Enable init container to fix volume permissions | `false` |
| `volumePermissions.image.registry` | Init container image registry | `docker.io` |
| `volumePermissions.image.repository` | Init container image | `busybox` |
| `volumePermissions.image.tag` | Init container image tag | `1.37` |

### NetworkPolicy parameters

| Key | Description | Default |
|-----|-------------|---------|
| `networkPolicy.enabled` | Enable NetworkPolicy | `false` |
| `networkPolicy.allowExternal` | Allow external connections | `true` |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.enabled` | Restrict ingress to specific pods | `false` |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.podSelector` | Pod selector for allowed ingress | `{}` |
| `networkPolicy.egressRules.denyConnectionsToExternal` | Deny external egress | `false` |

### TLS parameters

| Key | Description | Default |
|-----|-------------|---------|
| `tls.enabled` | Enable TLS | `false` |
| `tls.certificatesSecret` | Secret with TLS certificates | `""` |
| `tls.certFilename` | Certificate filename in secret | `""` |
| `tls.certKeyFilename` | Certificate key filename in secret | `""` |
| `tls.certCAFilename` | CA certificate filename in secret | `""` |

## Usage Examples

### Custom database and user

```yaml
auth:
  postgresPassword: "adminpass"
  username: "appuser"
  password: "apppass"
  database: "appdb"
```

### Using an existing secret

```yaml
auth:
  existingSecret: "my-postgres-secret"
  secretKeys:
    adminPasswordKey: "postgres-password"
    userPasswordKey: "password"
```

### Custom init scripts

```yaml
primary:
  initdb:
    scripts:
      init.sql: |
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
        CREATE SCHEMA IF NOT EXISTS app;
```

### Custom postgresql.conf

```yaml
primary:
  configuration: |
    max_connections = 200
    shared_buffers = 256MB
    effective_cache_size = 768MB
    log_min_duration_statement = 1000
```

### Restrict access with NetworkPolicy

```yaml
networkPolicy:
  enabled: true
  allowExternal: false
  ingressRules:
    primaryAccessOnlyFrom:
      enabled: true
      podSelector:
        app.kubernetes.io/name: myapp
```

### Disable persistence (for testing)

```yaml
primary:
  persistence:
    enabled: false
```

## Connecting to PostgreSQL

```bash
# Get admin password
export PGPASSWORD=$(kubectl get secret my-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

# Port-forward and connect
kubectl port-forward svc/my-postgresql 5432:5432 &
psql -h 127.0.0.1 -U postgres -p 5432
```

## Upgrading

```bash
helm upgrade my-postgresql . -f my-values.yaml
```