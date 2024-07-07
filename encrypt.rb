require 'openssl'
require 'base64'

# Function to encrypt a file
def encrypt_file(file_path, key)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key.slice(0, 32)
  iv = cipher.random_iv

  encrypted = ''
  File.open(file_path, 'rb') do |f|
    while chunk = f.read(4096)
      encrypted << cipher.update(chunk)
    end
    encrypted << cipher.final
  end

  File.open("#{file_path}.enc", 'wb') do |f|
    f.write(iv)
    f.write(encrypted)
  end

  puts "File encrypted and saved as #{file_path}.enc"
end

# Function to decrypt a file
def decrypt_file(file_path, key)
  decipher = OpenSSL::Cipher.new('AES-256-CBC')
  decipher.decrypt
  decipher.key = key.slice(0, 32)

  decrypted = ''
  File.open(file_path, 'rb') do |f|
    iv = f.read(16) # AES block size is 16 bytes
    decipher.iv = iv
    while chunk = f.read(4096)
      decrypted << decipher.update(chunk)
    end
    decrypted << decipher.final
  end

  original_file_path = file_path.sub('.enc', '')
  File.open(original_file_path, 'wb') do |f|
    f.write(decrypted)
  end

  puts "File decrypted and saved as #{original_file_path}"
end

# set secret key
key = 'This is a key123This is a key123' # Must be 32 bytes for AES-256
key = key.slice(0, 32) # Ensure key is exactly 32 bytes

# Encrypt the file
encrypt_file('example.txt', key)

# Result the file Encrypt
decrypt_file('result-encrypted.txt.enc', key)
