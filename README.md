
# Lua XOR Encryption System / Lua XOR Şifreleme Sistemi

## Overview / Genel Bakış

This project provides a simple yet effective method to obfuscate and protect Lua code using XOR encryption combined with Base64 encoding. It consists of two components:

Bu proje, Lua kodlarını gizlemek ve korumak için XOR şifreleme ve Base64 kodlamayı birleştiren basit ama etkili bir yöntem sunar. Sistem iki ana bileşenden oluşur:

- A **Python script** to encrypt raw Lua source code.  
  **Python betiği**, Lua kaynak kodunu şifreler.
- A **Lua script** to decrypt and execute the encrypted code at runtime.  
  **Lua betiği**, şifreli kodu çözümleyip çalıştırır.

---

## Encryption (Python) / Şifreleme (Python)

### File: `encrypt_lua.py` / Dosya: `encrypt_lua.py`

```python
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
```

### Usage / Kullanım:

1. Place the Lua code to be encrypted in `input.lua`.  
   Şifrelenecek Lua kodunu `input.lua` dosyasına yerleştirin.
2. Replace `YOUR_SECRET_KEY` with a strong key.  
   `YOUR_SECRET_KEY` yerine güçlü bir anahtar girin.
3. Run the script to generate `encrypted.txt`.  
   Betiği çalıştırarak `encrypted.txt` dosyasını oluşturun.

---

## Decryption & Execution (Lua) / Çözümleme ve Çalıştırma (Lua)

### File: `decrypt_executor.lua` / Dosya: `decrypt_executor.lua`

```lua
-- Kod yukarıdaki ile aynı, burada tekrar edilmedi
```

### Execution Flow / Çalışma Akışı:

1. `base64` is decoded back into binary.  
   `base64` kodlu veri ikili (binary) veriye dönüştürülür.
2. XOR is applied using a dynamically generated key.  
   Dinamik olarak oluşturulan bir anahtarla XOR işlemi yapılır.
3. The resulting Lua source is executed via `loadstring()`.  
   Ortaya çıkan Lua kodu `loadstring()` ile çalıştırılır.

---

## How the Key Works / Anahtar Sistemi Nasıl Çalışır?

To prevent hardcoding the raw XOR key, the Lua script uses a `diffs` array to obfuscate it. The `diffs` table contains relative differences between character codes.

Raw key: `mysecretkey123` → Converted to byte array → Transformed into `diffs` using:

Gerçek anahtar: `mysecretkey123` → Bayt dizisine çevrilir → Ardından farklara dönüştürülür:

```python
# Python: Convert key string to diffs array
key = "mysecretkey123"
bytes_ = [ord(c) for c in key]
diffs = [bytes_[0]]
for i in range(1, len(bytes_)):
    diffs.append(bytes_[i] - bytes_[i - 1])
print(diffs)
```

- Paste the resulting `diffs` into your Lua script.
- This makes the key hidden and less readable for reverse-engineering.

Ortaya çıkan `diffs` dizisini Lua tarafındaki `diffs` tablosuna yapıştırın. Bu yöntem, anahtarın doğrudan okunmasını engeller ve tersine mühendisliği zorlaştırır.

> **Note / Not:** If you change the encryption key in Python, don’t forget to update the `diffs` array accordingly.
> Python tarafında anahtarı değiştirirseniz, `diffs` dizisini de güncellemeyi unutmayın.

---

## Security Considerations / Güvenlik Notları

- XOR is simple and efficient but not cryptographically strong.  
  XOR yöntemi basit ve hızlıdır ancak kriptografik olarak güçlü değildir.
- The dynamic `diffs` mechanism adds obfuscation for the decryption key.  
  `diffs` mekanizması anahtarı gizleyerek ilave koruma sağlar.
- The decrypted code must be trusted. Avoid embedding sensitive logic or credentials.  
  Çözülen kod güvenilir olmalıdır. Hassas verileri doğrudan yerleştirmekten kaçının.
- While this method is not highly secure, it offers stronger protection than simply using `luac` compiled files. It provides a basic level of obfuscation, which may deter casual inspection, but should not be relied on for protecting critical logic or sensitive data.  
  Bu yöntem yüksek güvenlik sağlamasa da yalnızca `luac` ile korumaya kıyasla daha güçlü bir koruma sunar. Temel seviyede gizleme sağlar ve sıradan kullanıcıları caydırabilir, ancak hassas veriler ya da kritik işlemler için asla yeterli görülmemelidir.

---

## License / Lisans

This project is open source and free to use. No license is attached, but attribution is appreciated.  
Bu proje açık kaynaklıdır ve ücretsizdir. Belirli bir lisansla sınırlı değildir, ancak kaynak gösterilmesi memnuniyetle karşılanır.
