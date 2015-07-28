require 'csv'

class ForegroundElement
  BLOCK = :b
  HAZARD_UP = :h_spikes_up1
  HAZARD_LEFT = :h_spikes_left1
  HAZARD_DOWN = :h_spikes_right1
  HAZARD_RIGHT = :h_spikes_down1

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

foreground_types = [
  ForegroundElement::BLOCK,
  ForegroundElement::HAZARD_UP,
  ForegroundElement::HAZARD_RIGHT,
  ForegroundElement::HAZARD_DOWN,
  ForegroundElement::HAZARD_LEFT,
]

other_types = [
  :g, #goal
  :grapple, #grapple
  :p, #player starting position
]

valid_types = foreground_types + other_types

foreground_elements = CSV.open('../pfgame.data/levels/level1/layout.txt', 'r').map do |row|
  row.map do |element|
    if element != nil
      raise "invalid type: #{element}" unless valid_types.include?(element.to_sym)
      ForegroundElement.new(element)
    end
  end
end

p foreground_elements
