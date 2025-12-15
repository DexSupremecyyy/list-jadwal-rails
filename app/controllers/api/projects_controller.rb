module Api # Wajib di bungkus module api karena kode ini berada di dalam folder api
  class ProjectsController < ApplicationController
    # Skip satpam CSRF karena api mau di akses di postman, bukan di browser
    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    before_action :cek_token

    # Ngejalanin method set_projek dulu sebelum menjalankan method show, update, destroy
    before_action :set_project, only: [:show, :update, :destroy]

    def index # berisi data dari database

      # variable nya bebas mau nama apa saja
      # Isi dari variable nya yaitu mengambil semua data tabel projects
      # 
      # Q : apa bedanya Project dan projects? kenapa gak projects.all ?
      # A : untuk Project itu adalah model yang isinya adalah tabel plular(banyak data) yaitu tabel projects
      # Project = Model yang berisi tabel projects
      # projects = tabel bernama projects 
      @projects = Project.all # Untuk Project.all itu perintah Active Record (ORM) buat bilang ke SQL: "SELECT * FROM projects".


      # Ini untuk merender menjadi format json dengan ngambil data dari variable @project
      # untuk yang status: :ok fungsi nya untuk megirimkan status sukses dengan kode 200(sukses)
      render json: @projects, status: :ok 
    end

    # Method Show(READ)
    def show
      if @projects # Jika ada data dari projek
        render json: @projects, status: :ok # Maka akan merender data dengan format json 
      else # Jika tidak menemukan data
        render json: { error: "Data Tidak Ditemukan" }, status: :not_found # Menampilkan output error dengan format json
      end
    end

    # Method Crete(New)
    def create
      @projects = Project.new(project_params) # Variable @project ini berisi perintah untuk : Membuat record(baris data) baru di table projects dengan mengambil data dari method project_params yang ada di bawah(Dia ngambil data seperti tittle, description, deadline)

      if @projects.save # Jika @project tersimpan?
        render json: @projects, status: :created # Maka akan menampilkan data dari @project dengan format json beserta status 201(created)
      else
        render json: { error: @projects.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Method Update(Edit)
    def update
      return render json: { error: "Project Not Found ❌" }, status: :not_found unless @projects # Melakukan pengecekan jika data dari variable @project tidak ada, maka dia akan menampilkan Error notfound, (unless) kecuali jika ada maka akan melanjutkan perintah yang ada di bawah 
      # Return = menendang/mengembalikan/menghentikan untuk melanjutkan perintah di bawah nya(masih di dalam method ya)

      
      if @projects.update(project_params) # jika project melakukan update dengan mengambil data dari method project_params
        render json: { message: "Edit Success ✅", data: @projects}, status: :ok # maka akan menampilkan success
      else # Jika tidak maka akan menampilkan error
        render json: { error: @projects.errors.full_messages }, status: :unprocessable_entity
      end
    end


    # Method Delete
    def destroy
      return render json: { error: "Project Not Found ❌"}, status: :not_found unless @projects # Melakukan pengecekan jika data dari variable @project tidak ada, maka dia akan menampilkan Error notfound, (unless) kecuali jika ada maka akan melanjutkan perintah yang ada di

      @projects.destroy
      head :no_content # Untuk menampilkan sukses di header 204
    end

    # Ini berfungsi sebagai pembatas method yang bisa di panggil, dan method yang di bawah private hanya bisa di panggil di controller saja (Global limited)
    private
    
    # Method untuk validasi token
    def cek_token
      return unless request.format.json? # Kembalikan kecuali kalo ada yang memasukan format .json

      token_from_user = request.headers["X-Api-Token"] # Buat Variable untuk menyimpan input header (di postman)
      token_from_server = ENV["API_TOKEN"] # Buat variable untuk menyimpan kunci yang ada di .env

      if token_from_user.blank? || token_from_user != token_from_server # Jika token dari user gada dan jika token dari user tidak sama dengan token/kunci dari server
        render json: { error: "Dilarang Masuk"}, status: :unauthorized # maka akan menampilkan error dilarang masuk dengan format .json
      end
    end

    # Method untuk mencari project menggunakan parameter id
    def set_project
      @projects = Project.find_by(id: params[:id]) # variable @project = data dari table projects di cari menggunakan parameter ID
    end

    # Method untuk mengatur format .json menjadi sesuai yang di inginkan (Untuk yang ingin test di postman)
    def project_params 
      params.expect(project: [ :tittle, :description, :deadline ]) # Ekspetasi params nya adalah dengan label project: dengan isi tittle, desscription, dan deadline

      # Format JSON nya
      # {
      #   "project": {
      #       "tittle": "",
      #       "description": "",
      #       "deadline": ""
      #   }
      # }

    end
  end
end