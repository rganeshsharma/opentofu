# ============================================================
# Argo CD - DigitalOcean RKE2 Platform
# Helm chart: argo-cd
#
# Architecture:
#
# Internet
#    |
#    v
# DigitalOcean LoadBalancer
#    |
#    v
# Envoy Gateway
#    |
#    v
# Gateway API / HTTPRoute
#    |
#    v
# argocd-server (ClusterIP)
#
# TLS terminates at Envoy Gateway.
# Argo CD itself runs HTTP internally.
#
# No PVC required.
# ============================================================