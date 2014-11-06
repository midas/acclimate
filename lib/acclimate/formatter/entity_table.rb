module Acclimate
  class Formatter
    class EntityTable < Acclimate::Formatter

      def render
        renderred
      end

    protected

      def renderred
        @renderred ||= capture do
          table do
            attributes.each do |attr|
              row do
                column label_column_value( attr ), label_column_options
                column val_column_value( attr ),   val_column_options
              end
            end
          end
        end
      end

      def label_column_value( attr )
        attr
      end

      def label_column_options
        {
          align: 'right',
          color: :cyan,
          width: col_width
        }
      end

      def val_column_value( attr )
        send( attr )
      end

      def val_column_options
        {
          width: 50
        }
      end

      def attributes
        raise NotImplementedError
      end

      def col_width
        @col_width ||= attributes.map( &:size ).max + 0
      end

    end
  end
end
