import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Validasi username
  String? validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  // Validasi password
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (!value.contains('hajioka')) {
      return 'Password harus mengandung kata "hajioka"';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LOGIN', style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
            // Validasi untuk Username
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) => validateUsername(value!),
            ),
            SizedBox(height: 16.0),
            // Validasi untuk Password
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) => validatePassword(value!),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validasi sebelum melakukan login
                if (validateUsername(_usernameController.text) == null &&
                    validatePassword(_passwordController.text) == null) {
                  // Implement login logic here
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  print('Username: $username, Password: $password');
                } else {
                  print('Form tidak valid');
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProdukListScreen();
                    },
                  ),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------

class ProdukListScreen extends StatefulWidget {
  @override
  _ProdukListScreenState createState() => _ProdukListScreenState();
}

class _ProdukListScreenState extends State<ProdukListScreen> {
  List<Map<String, dynamic>> produkList = [
    {'nama': 'Baju', 'harga': 'Harga: Rp 100.000'},
    {'nama': 'Sepatu', 'harga': 'Harga: Rp 150.000'},
    {'nama': 'Mouse', 'harga': 'Harga: Rp 120.000'},
    {'nama': 'Keyboard', 'harga': 'Harga: Rp 200.000'},
    {'nama': 'Headset', 'harga': 'Harga: Rp 180.000'},
    {'nama': 'Produk 6', 'harga': 'Harga: Rp 150.000'},
    {'nama': 'Produk 7', 'harga': 'Harga: Rp 150.000'},
    {'nama': 'Produk 8', 'harga': 'Harga: Rp 150.000'},
    {'nama': 'Produk 9', 'harga': 'Harga: Rp 150.000'},
    
  ];

  TextEditingController _newProdukController = TextEditingController();
  TextEditingController _newHargaController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  // Fungsi untuk menambah produk
  void tambahProduk(String nama, String harga) {
    setState(() {
      if (nama.isNotEmpty && harga.isNotEmpty) {
        produkList.add({'nama': nama, 'harga': harga});
        _newProdukController.clear();
        _newHargaController.clear();
      }
    });
  }

  // Fungsi untuk menghapus produk
  void hapusProduk(int index) {
    setState(() {
      produkList.removeAt(index);
    });
  }

  // Fungsi untuk mencari produk
  List<Map<String, dynamic>> cariProduk(String keyword) {
    return produkList
        .where((produk) => produk['nama']
            .toLowerCase()
            .contains(keyword.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Produk'),
        actions: [
          // Ikon refresh di app bar
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Tambahkan logika refresh di sini
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Form untuk mencari produk
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (keyword) {
                setState(() {});
              },
            ),
          ),
          // ListView untuk menampilkan daftar produk
          Expanded(
            child: ListView.builder(
              itemCount: cariProduk(_searchController.text).length,
              itemBuilder: (context, index) {
                Map<String, dynamic> produk =
                    cariProduk(_searchController.text)[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text('${index + 1}.        ${produk['nama']}'),
                      subtitle: Text('             ${produk['harga']}'),
                      // Aksi untuk menghapus produk dengan ikon
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          hapusProduk(produkList.indexOf(produk));
                        },
                      ),
                    ),
                    Divider(), // Garis pemisah antar produk
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // Ikon tambah produk di bawah kanan layer
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tampilkan popup form untuk menambahkan produk
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Tambah Produk Baru'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _newProdukController,
                      decoration: InputDecoration(labelText: 'Nama Produk'),
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _newHargaController,
                      decoration: InputDecoration(labelText: 'Harga'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      tambahProduk(
                          _newProdukController.text, _newHargaController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text('Tambah'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
