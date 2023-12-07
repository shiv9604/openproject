#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2023 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module ProjectCustomFields
  module Sections
    module ProjectCustomFields
      class ShowComponent < ApplicationComponent
        include ApplicationHelper
        include OpPrimer::ComponentHelpers

        def initialize(project_custom_field:, project_custom_field_values:)
          super

          @project_custom_field = project_custom_field
          @project_custom_field_values = project_custom_field_values
        end

        private

        def render_formated_value
          return if @project_custom_field_values.empty?

          if @project_custom_field_values.one?
            render_single_value(@project_custom_field_values.first)
          else
            render_multiple_values(@project_custom_field_values)
          end
        end

        def render_single_value(value)
          formated_value(value)
        end

        def render_multiple_values(values)
          values.map do |value|
            formated_value(value)
          end.join(", ")
        end

        def formated_value(value)
          case @project_custom_field.field_format
          when "text"
            ::OpenProject::TextFormatting::Renderer.format_text(value.typed_value)
          when "date"
            format_date(value.typed_value)
          else
            value.typed_value&.to_s
          end
        end
      end
    end
  end
end
