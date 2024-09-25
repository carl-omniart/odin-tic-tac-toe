# frozen_string_literal: true

module MinimaxHelpers
  State = Struct.new(:value, :successors) do
    def cutoff?(_depth)
      !!value
    end

    def each_action(&block)
      return enum_for(:each_action) unless block

      successors.each_key(&block)
    end

    def successor(action)
      successors[action]
    end
  end

  def self.tree(val_or_ary)
    val_or_ary.is_a?(Array) ? array = val_or_ary : value = val_or_ary
    return State.new(value, {}) if value

    successors = array.each_with_index.to_h { |ary, i| [i, tree(ary)] }
    State.new nil, successors
  end
end
