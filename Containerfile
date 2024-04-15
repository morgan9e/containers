  RUN cat <<'EOF' | patch -p1
    --- /tmp/tmp.c15B0KXXhC	2024-03-31 18:04:56.569766057 +0000
+++ /etc/ssh/sshd_config	2024-03-31 18:05:13.917722178 +0000
@@ -11,7 +11,7 @@
 
 Include /etc/ssh/sshd_config.d/*.conf
 
-#Port 22
+Port 2222
 #AddressFamily any
 #ListenAddress 0.0.0.0
 #ListenAddress ::
@@ -30,7 +30,7 @@
 # Authentication:
 
 #LoginGraceTime 2m
-#PermitRootLogin prohibit-password
+PermitRootLogin prohibit-password
 #StrictModes yes
 #MaxAuthTries 6
 #MaxSessions 10
  EOF
