module RequestForChangesHelper

  def pretty_dropdown_link_for_person rfc, person_symbol
    link_to("#{person_symbol.to_s[0].upcase}: #{rfc.send("#{person_symbol}_name_with_description")}", '#', :class => 'btn align-left') if rfc.send(person_symbol)
  end

end
