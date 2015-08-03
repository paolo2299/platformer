require 'csv'

class ForegroundElement
  BLOCK = :b
  HAZARD_UP = :h_spikes_up1
  HAZARD_LEFT = :h_spikes_left1
  HAZARD_DOWN = :h_spikes_down1
  HAZARD_RIGHT = :h_spikes_right1

  attr_reader :type

  def initialize(type)
    @type = type.to_sym
  end

  def block?
    type == BLOCK
  end

  def hazard_up?
    type == HAZARD_UP
  end

  def hazard_right?
    type == HAZARD_RIGHT
  end

  def hazard_down?
    type == HAZARD_DOWN
  end

  def hazard_left?
    type == HAZARD_LEFT
  end
end

class StaticForeground
  FOREGROUND_TYPES = [
    ForegroundElement::BLOCK,
    ForegroundElement::HAZARD_UP,
    ForegroundElement::HAZARD_RIGHT,
    ForegroundElement::HAZARD_DOWN,
    ForegroundElement::HAZARD_LEFT,
  ]

  OTHER_TYPES = [
    :g, #goal
    :grapple, #grapple
    :p, #player starting position
  ]

  VALID_TYPES = FOREGROUND_TYPES + OTHER_TYPES

  attr_reader :elements

  def self.from_file(filepath)
    foreground_elements = CSV.open(filepath, 'r').map do |row|
      row.map do |element|
        if element != nil
          raise "invalid type: #{element}" unless VALID_TYPES.include?(element.to_sym)
          if FOREGROUND_TYPES.include?(element.to_sym)
            ForegroundElement.new(element)
          end
        end
      end
    end

    new(foreground_elements)
  end

  def initialize(elements)
    @elements = elements
    validate!
  end

  def validate!
    raise "unequal rows" if rows.any?{|row| row.size != width}
  end

  def width
    rows.first.size
  end

  def height
    rows.size
  end

  def rows
    elements
  end
end
