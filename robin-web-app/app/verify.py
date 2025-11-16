from nacl.signing import SigningKey, VerifyKey

# generate keys
sk = SigningKey.generate()
vk = sk.verify_key

msg = b"hello"
signed = sk.sign(msg)

# verify
vk.verify(signed)  # raises if signature invalid
print("verified:", signed.message == msg)