require 'openssl'
require 'base64'

# Function to decrypt a file
def decrypt_file(file_path, key, output_file)
  decipher = OpenSSL::Cipher.new('AES-256-CBC')
  decipher.decrypt
  decipher.key = key.ljust(32, '0')[0, 32] # Ensure key is exactly 32 bytes

  decrypted = ''
  File.open(file_path, 'rb') do |f|
    iv = f.read(16) # AES block size is 16 bytes
    decipher.iv = iv
    while chunk = f.read(4096)
      decrypted << decipher.update(chunk)
    end
    decrypted << decipher.final
  end

  File.open(output_file, 'wb') do |f|
    f.write(decrypted)
  end

  puts "File decrypted and saved as #{output_file}"
end

# Example usage
key = 'This is a key123This is a key123' # Example key
key = key.ljust(32, '0')[0, 32] # Ensure key is exactly 32 bytes

# Decrypt the file and save the result to result-decrypt.txt
decrypt_file('example.txt.enc', key, 'result-decrypt.txt')
