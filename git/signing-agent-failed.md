# Sign_and_Send_Pubkey Error when Running Git Push
Error:
```text
angela@debian$ /repo[master *]: git push
sign_and_send_pubkey: signing failed: agent refused operation
Forbidden
fatal: Could not read from remote repository.
```

This occured after an in-place OS update from stretch to buster.  Check the permissions of the SSH key you're using:
```bash
ls -l ~/.ssh
```
Permissions of the affected key:
```text
-rw-r--r-- 1 angela angela  1766 Aug 14  2018 id_rsa
-rw-r--r-- 1 angela angela   395 Aug 14  2018 id_rsa.pub
```

Assign proper permissions to the affected key(s):
```bash
chmod 600 id_rsa && chmod 644 id_rsa.pub
```

Correct permissions:
```text
-rw------- 1 angela angela  1766 Aug 14  2018 id_rsa
-rw-r--r-- 1 angela angela   395 Aug 14  2018 id_rsa.pub
```

Run `git push` again and it should work!
