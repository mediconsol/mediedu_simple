class DocumentsController < ApplicationController
  before_action :set_document, only: [:show]
  
  def index
    @documents = Document.all
    
    # 카테고리 필터링
    if params[:category].present?
      @documents = @documents.where(category: params[:category])
    end
    
    # 검색 필터링
    if params[:search].present?
      @documents = @documents.where("title LIKE ?", "%#{params[:search]}%")
    end
    
    # 최신순으로 정렬
    @documents = @documents.order(created_at: :desc)
  end

  def show
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    
    # 임시 사용자 설정 (나중에 실제 인증 시스템으로 교체)
    @document.uploaded_by = get_or_create_demo_user
    @document.hospital = get_or_create_demo_hospital
    
    if @document.save
      redirect_to document_path(@document), notice: "문서가 성공적으로 업로드되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_document
    @document = Document.find(params[:id])
  end
  
  def document_params
    params.require(:document).permit(:title, :content, :category, :status)
  end
  
  def get_or_create_demo_user
    hospital = get_or_create_demo_hospital
    User.find_or_create_by(email: "demo@example.com") do |user|
      user.name = "데모 사용자"
      user.hospital = hospital
      user.role = :admin
      user.department = :management
      user.active = true
    end
  end
  
  def get_or_create_demo_hospital
    Hospital.find_or_create_by(domain: "demo-hospital.mediedu.pro") do |hospital|
      hospital.name = "데모 병원"
      hospital.active = true
    end
  end
end
