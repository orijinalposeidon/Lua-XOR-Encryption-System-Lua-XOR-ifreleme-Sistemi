import base64

def xor_encrypt(data: bytes, key: bytes) -> bytes:
    return bytes([data[i] ^ key[i % len(key)] for i in range(len(data))])

def encrypt_lua_code(code: str, key: str) -> str:
    encrypted = xor_encrypt(code.encode('utf-8'), key.encode('utf-8'))
    return base64.b64encode(encrypted).decode('utf-8')

if __name__ == "__main__":
    key = "YOUR_SECRET_KEY"  # ŞİFRENİZİ BURAYA YAZIN

    with open("input.lua", "r", encoding="utf-8") as f:
        lua_code = f.read()

    encrypted_code = encrypt_lua_code(lua_code, key)

    with open("encrypted.txt", "w", encoding="utf-8") as f:
        f.write(encrypted_code)

    print("Encryption completed successfully. / Şifreleme işlemi başarıyla tamamlandı.")
