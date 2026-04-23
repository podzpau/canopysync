class Admin::ConceptEntitiesController < AdminController
  before_action :set_entity, only: [ :edit, :update, :destroy ]

  def index
    @entities = ConceptEntity.order(:key)
  end

  def new
    @entity = ConceptEntity.new
  end

  def create
    @entity = ConceptEntity.new(entity_params)
    if @entity.save
      redirect_to admin_concept_entities_path, notice: "Entity created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @entity.update(entity_params)
      redirect_to admin_concept_entities_path, notice: "Entity updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entity.destroy
    redirect_to admin_concept_entities_path, notice: "Entity deleted."
  end

  private

  def set_entity
    @entity = ConceptEntity.find(params[:id])
  end

  def entity_params
    params.require(:concept_entity).permit(:key, :name, :wikipedia_url, :wikidata_url)
  end
end
