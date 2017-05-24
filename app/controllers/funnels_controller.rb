class FunnelsController < ShopifyApp::AuthenticatedController
  before_action :set_funnel, only: [:show, :edit, :update, :destroy]


  # Page Render Function
  # --------------------
  # Renders the "Funnels" Page which lists out all
  # the funnels for the current app instance
  #
  def index

    # Get the current app loaded
    @app = MailfunnelsUtil.get_app

    # Get all Funnel models
    @funnels = Funnel.where(app_id: @app.id)

    logger.info @funnels
  end


  # Page Render Function
  # --------------------
  # Renders the "Edit Funnel" Page which allows user
  # to edit the funnel using drag and drop funnel builder
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the funnel we are editing
  #
  def edit_funnel

    # Get the Current App ID
    @app = MailfunnelsUtil.get_app

    # Find the funnel from the DB
    @funnel = Funnel.find(params[:funnel_id])

    @triggers = Trigger.where(app_id: @app.id)

  end

  # USED WITH AJAX
  # Creates a new Funnel Model
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current app being used
  # name: Name of the Funnel
  # description: description of the funnel
  # trigger_id: ID of the Trigger for Funnel
  # email_list_id: ID of the EmailList for Funnel
  #
  def ajax_create_funnel

    # Create new Funnel Model
    funnel = Funnel.new

    # Update the Fields of Funnel Model
    funnel.app_id = params[:app_id]
    funnel.trigger_id = params[:trigger_id]
    funnel.email_list_id = params[:email_list_id]
    funnel.name = params[:name]
    funnel.description = params[:description]
    funnel.num_emails_sent = 0
    funnel.num_revenue = 0.0

    # Save and verify Funnel and return correct JSON response
    if funnel.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json
  end

  # USED WITH AJAX
  # --------------
  # Adds a new node to the funnel being edited
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the funnel the node is being added on
  # name: Name of the Node
  # email_template_id: ID of the trigger the node is related to
  # delay_time: The delay time for sending the email
  #
  def ajax_add_node

    # Create a new Node Instance
    node = Node.new

    # Update the fields of Node Instance
    node.funnel_id = params[:funnel_id]
    node.email_template_id = params[:email_template_id]
    node.name = params[:name]
    node.delay_time = params[:delay_time]
    node.top = 60
    node.left = 500
    node.num_emails = 0
    node.num_emails_sent = 0
    node.num_revenue = 0.0
    node.num_emails_opened = 0
    node.num_emails_clicked = 0



    # Save and verify Node and return correct JSON response
    if node.save!
      final_json = JSON.pretty_generate(result = {
          :success => true,
          :id => node.id
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end

  # USED WITH AJAX
  # --------------
  # Adds a new link to the funnel being edited
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the funnel the link is being added on
  # from_operator_id: Operator we are starting link from
  # to_operator_id: Operator we are ending the link on
  #
  def ajax_add_link

    # Create a new Link Instance
    link = Link.new

    # Update the fields of Link Instance
    link.funnel_id = params[:funnel_id]
    link.from_node_id = params[:to_operator_id].to_i

    if params[:from_operator_id].to_i === 0
      # If the link starts at the start node, set slink to 1
      link.start_link = 1
    else
      # Otherwise, set slink to 0 (false) and set from_operator_id
      link.start_link = 0
      link.from_node_id = params[:from_operator_id].to_i
    end

    # Save and verify Link and return correct JSON response
    if link.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end


  # USED WITH AJAX
  # --------------
  # Loads a JSON representation of nodes on funnel builder
  # to be loaded ino flowchart plugin
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the Funnel to get nodes for
  #
  def ajax_load_funnel_json

    # Load all the Nodes and Links for the current Funnel
    @nodes = Node.where(funnel_id: params[:funnel_id])
    @links = Link.where(funnel_id: params[:funnel_id])

    # Create a new array to hold the operators
    operators = Hash.new

    # Create start operator
    operators[0] =
        {
            :top => 20,
            :left => 20,
            :properties => {
                :title => 'Start',
                class: 'flowchart-operator-start-node',
                inputs: {},
                outputs: {
                    output_1: {
                        label: ' ',
                    }
                }
            }
        }

    # For every Node we have in the DB, create an operator with its fields
    @nodes.each do |node|

      operators[node.id] =
          {
              :top => node.top,
              :left => node.left,
              :properties => {
                  :title => node.name,
                  class:'flowchart-operator-email-node',
                  :inputs => {
                      :input_1 => {
                          :label => ' '
                      }
                  },
                  :outputs => {
                      :output_1 => {
                          :label => ' '
                      }
                  }
              }
          }


    end

    # Create a new links array
    links = Hash.new

    # For every Link for the funnel, create a flowchart link with its fields
    @links.each do |link|

      if link.start_link === 1
        fromNode = 0
      else
        fromNode = link.from_node_id
      end

      links[link.id] =
          {
              :fromConnector => 'output_1',
              :toConnector => 'input_1',
              :fromOperator => fromNode,
              :toOperator => link.to_node_id,
          }
    end



    # Create data JSON with operators and links
    data = JSON.pretty_generate({
                                    'operators' => operators,
                                    'links' => links
                                })


    # Return JSON array with flowchart data
    render json: data

  end


  # USED WITH AJAX
  # --------------
  # Updates the node on the funnel when moved
  #
  # PARAMETERS
  # ----------
  # node_id: ID of the node that was updated
  # top: Distance from top in pixels
  # left: Distance from left in pixels
  #
  def ajax_save_node

    # Get the Node from the DB
    node = Node.where(id: params[:node_id]).first

    # Update the Node
    node.top = params[:top]
    node.left = params[:left]

    # Save and verify Node and return correct JSON response
    if node.save!
      final_json = JSON.pretty_generate(result = {
          :success => true,
          :id => node.id
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end


  # USED WITH AJAX
  # --------------
  # Returns a JSON array of all info for the node
  # used for the view node info modal
  #
  # PARAMETERS
  # ----------
  # node_id: ID of the node we are getting info for
  #
  #
  def ajax_load_node_info

    # Get the Node from the DB
    node = Node.find(params[:node_id])

    # Populate data Hash with node info
    data = {
        :node_id => node.id,
        :node_name => node.name,
        :node_delay_time => node.delay_time,
        :node_total_emails => node.num_emails,
        :node_emails_sent => node.num_emails_sent,
        :node_emails_opened => node.num_emails_clicked,
        :node_emails_clicked => node.num_emails_opened,
        :node_total_revenue => node.num_revenue,
        :email_template_id => node.email_template_id,
        :email_template_name => node.email_template.name,
    }


    # Return data as JSON
    render json: data

  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funnel
      @funnel = Funnel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def funnel_params
      params.require(:funnel).permit(:name, :description, :num_emails_sent, :num_revenue, :app_id, :trigger_id, :email_list_id)
    end
end
