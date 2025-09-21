# Modified values for gitea.
service:
  ssh:
    type: NodePort
    port: 22
    clusterIP: ""
    loadBalancerIP:
    nodePort: 30022
    externalTrafficPolicy: Local

ingress:
  enabled: true
  className: "nginx"
  pathType: Prefix
  hosts:
    - host: git.kube.lime.lan
      paths:
        - path: /

gitea:
  admin:
    existingSecret:
    username: admin
    password: "$GITEA_ADMIN_PASSWORD"
    email: "admin@lime.lan"
    passwordMode: keepUpdated

  ## @param gitea.metrics.enabled Enable Gitea metrics
  metrics:
    enabled: true

  ## @param gitea.ldap LDAP configuration
  ldap:
    - name: "LDAP1"
      existingSecret: ""  # (Optional) Kubernetes Secret name holding bindPassword
      securityProtocol: "ldaps"  # | ldaps (636) | unencrypted (389) | unsecured (389)
      skipTlsVerify: # Else ctnr must have LIME.LAN Root CA cert 
      host: "dc1.lime.lan"
      port: 636 # 636
      userSearchBase: "OU=OU1,DC=lime,DC=lan"
      userFilter: "(&(objectClass=user)(sAMAccountName=%s))" # Matches AD user(s) having: Ojbect class: User
      adminFilter: ""
      emailAttribute: mail
      bindDn: "CN=ldap-gitea,OU=Service Accounts,OU=OU1,DC=lime,DC=lan"
      bindPassword: "$GITEA_LDAP_BIND_PASSWORD"
      usernameAttribute: sAMAccountName
      #publicSSHKeyAttribute: "sshPublicKey"

# extraVolumes:
#   - name: ldap-ca
#     secret:
#       secretName: ldap-gitea-ca
# extraContainerVolumeMounts:
#   - name: ldap-ca
#     mountPath: /usr/local/share/ca-certificates/lime-root-ca.crt
#     subPath: lime-root-ca.pem
#     readOnly: true
# extraInitVolumeMounts:
#   - name: ldap-ca
#     mountPath: /usr/local/share/ca-certificates/lime-root-ca.crt
#     subPath: lime-root-ca.pem
#     readOnly: true

# DaemonSet
postgresql-ha:
  enabled: false  # Default true

# Single instance
postgresql:
  enabled: true   # Default false
  
