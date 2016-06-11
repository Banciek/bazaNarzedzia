class ToolsCardsPdf < Prawn::Document
  def initialize(tools_card, employee, company, tools)
    
    font_families.update("Liberation Serif" => {
    :normal => Rails.root.join("lib/fonts/liberation/LiberationSerif-Regular.ttf"),
    :italic => Rails.root.join("lib/fonts/liberation/LiberationSerif-Italic.ttf"),
    :bold => Rails.root.join("lib/fonts/liberation/LiberationSerif-Bold.ttf"),
    :bold_italic => Rails.root.join("lib/fonts/liberation/LiberationSerif-BoldItalic.ttf")
    })

    super()
    @tools_card = tools_card
    @employee = employee
    @company = company 
    @tools = tools

    font "Liberation Serif"
    font_size 12
    header
    #text_content
    text_content2
    table_content
    footer
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    draw_text "#{@company.city}: #{DateTime.now.to_date}", at: [420, 710], valign: :right
    
    text "#{@company.full_name}"
    text "#{@company.zip_code} #{@company.city}"
    text "#{@company.street} #{@company.street_address}"
    text "Nip: #{@company.nip} | Regon: #{@company.regon}"
    move_down 40
    text "Karta narzędzi/urządzen", size: 14, style: :bold, align: :center
    move_down 20
    #image "#{Rails.root}/app/assets/images/header.png", width: 530, height: 150
  end

  def text_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 50

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 270, :height => 300) do
      text "Lorem ipsum", size: 15, style: :bold
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse interdum semper placerat. Aenean mattis fringilla risus ut fermentum. Fusce posuere dictum venenatis. Aliquam id tincidunt ante, eu pretium eros. Sed eget risus a nisl aliquet scelerisque sit amet id nisi. Praesent porta molestie ipsum, ac commodo erat hendrerit nec. Nullam interdum ipsum a quam euismod, at consequat libero bibendum. Nam at nulla fermentum, congue lectus ut, pulvinar nisl. Curabitur consectetur quis libero id laoreet. Fusce dictum metus et orci pretium, vel imperdiet est viverra. Morbi vitae libero in tortor mattis commodo. Ut sodales libero erat, at gravida enim rhoncus ut."
    end

    bounding_box([300, y_position], :width => 270, :height => 300) do
      text "Duis vel", size: 15, style: :bold
      text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
    end

  end

  def text_content2
    text "#{content_exists?}", align: :justify
  end

  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    move_down(50)
    text "Lista narzędzi:", style: :bold
    move_down(10)
    table tool_rows do
      row(0).font_style = :bold
      #self.cell_style = {border_lines: [:dotted, :dotted]}
      #row(0).cell_style = {border_lines: [:dotted, :solid]}
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      row(0).row_colors = "DDDDDD"
      self.width = 540
      #self.column_widths = [40, 400, 300, 60]
    end
  end

  def tool_rows
    [['#', 'Nazwa', 'Ilosc', 'Nr.ew.']] +
      @tools.map.with_index(1) do |tool, index|
      [index, tool.name, tool.quantity, tool.id]
    end
  end

  def footer
    #draw_text ".........................", at: [0,0]
    bounding_box([0,20], :width => 100, :height => 50) do
      text "................................."
      text "(podpis osoby przyjmującej dokument)", size: 8, align: :center
    end

    bounding_box([440,16], width: 100, height: 50) do
      text "................................."
      text "(podpis pracownika)", size: 8, align: :center
    end    
    
  end

  def content_exists?
    if @tools_card.content.blank?
      return "Tu będzie treść dokumentu"
    else
      return @tools_card.content
    end
  end

end