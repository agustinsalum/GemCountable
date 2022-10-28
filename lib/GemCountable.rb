# frozen_string_literal: true

require_relative "GemCountable/version"

module GemCountable
  module Countable
    module CountableMethodClass
      # método de clase que al invocarse realiza las tareas necesarias para contabilizar las invocaciones al método de instancia cuyo nombre es sym (un símbolo).
      def count_invocations_of(sym)
        alias_method "#{sym}_copia", sym
        define_method(sym)  do
          # El self(metodo sym) no es obligatorio con define_method
          self.contabilizar[sym]+=1
          self.send("#{sym}_copia")
        end
      end
    end
    
    # Cuando un modulo es incluido en una clase se ejecuta este metodo (no es metodo de clase)
    def self.included(base)
      base.extend(CountableMethodClass)
    end
    
    def contabilizar
      # ||=  si el hash esta vacio entonces retorna false... true en caso contrario
      @d||=Hash.new(0) # Las nuevas keys van a iniciarse con un value en cero, usado como contador
    end
    
    # método de instancia que devuelve un valor booleano indicando si el método llamado sym fue invocado al menos una vez en la instancia receptora.
    def invoked?(sym)
      @d[sym] > 0
    end
    
    # método de instancia que devuelve la cantidad de veces que el método identificado por sym fue invocado en la instancia receptora.
    def invoked(sym)
      @d[sym]
    end
  end
end