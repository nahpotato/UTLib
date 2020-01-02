/* Utlib - Yet another wrapper to the YouTube Data API v3
 * Copyright (C) 2019 Nahuel Gomez Castro
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

using Gee;

namespace Utlib {

    public class PropertyService : Object {

        private Object object;
        private ObjectClass klass;
        private Gee.List<Property> properties;

        public PropertyService (Object object) {
            this.object = object;
            this.klass = (ObjectClass) object.get_type ().class_ref ();
        }

        construct {
            this.properties = new ArrayList<Property> ();
        }

        public bool install_property (string property_name,
                                      string? property_name_in_request = null)
        {
            var pspec = this.klass.find_property (property_name);
            return_val_if_fail (pspec != null, false);

            var prop_name_in_request = property_name_in_request ?? property_name;

            return properties.add (new Property () {
                property_name = property_name,
                property_type = pspec.value_type,
                property_name_in_request = prop_name_in_request
            });
        }

        public string? parse_properties () {
            var parsed = new ArrayList<string> ();

            foreach (var property in this.properties) {
                var property_parsed = property.parse_property (this.object);
                return_val_if_fail (property_parsed != null, null);
                parsed.add (property_parsed);
            }

            return string.joinv ("&", parsed.to_array ());
        }
    }
}