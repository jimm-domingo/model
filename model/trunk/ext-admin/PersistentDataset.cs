using System.Collections.Generic;
using System.IO;
using System.Xml.Serialization;

namespace Landis.PlugIns.Admin
{
    /// <summary>
    /// A persistent collection of information about installed plug-ins.
    /// </summary>
    [XmlRoot("PlugInDataset")]
    public class PersistentDataset
    {
        /// <summary>
        /// Information about a plug-in.
        /// </summary>
        public class PlugInInfo
        {
            /// <summary>
            /// The plug-in's name.
            /// </summary>
            [XmlAttribute]
            public string Name;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// The plug-in's version.
            /// </summary>
            [XmlAttribute("Version")]
            public string Version;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// The plug-in's type.
            /// </summary>
            [XmlElement("Type")]
            public string TypeName;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// The plug-in's assembly.
            /// </summary>
            [XmlElement("Assembly")]
            public string AssemblyName;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// The class in the plug-in's assembly that represents the plug-in.
            /// </summary>
            [XmlElement("Class")]
            public string ClassName;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// A brief description of the plug-in.
            /// </summary>
            public string Description;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// The path to the plug-in's user guide.
            /// </summary>
            /// <remarks>
            /// The path is relative to the documentation directory of a
            /// LANDIS-II installation.
            /// </remarks>
            [XmlElement("UserGuide")]
            public string UserGuidePath;

            //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            /// <summary>
            /// Initializes a new instance with all empty fields.
            /// </summary>
            public PlugInInfo()
            {
            }
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// The plug-ins in the collection.
        /// </summary>
        [XmlArrayItem("PlugIn")]
        public List<PlugInInfo> PlugIns;

        //---------------------------------------------------------------------

        /// <summary>
        /// Initializes a new instance with an empty list of plug-ins.
        /// </summary>
        public PersistentDataset()
        {
            PlugIns = new List<PlugInInfo>();
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// Loads a plug-in information dataset from a file.
        /// </summary>
        public static PersistentDataset Load(string path)
        {
            PersistentDataset dataset;
            using (TextReader reader = new StreamReader(path)) {
                XmlSerializer serializer = new XmlSerializer(typeof(PersistentDataset));
                dataset = (PersistentDataset) serializer.Deserialize(reader);
            }
            return dataset;
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// Saves the driver dataset to a file.
        /// </summary>
        public void Save(string path)
        {
            using (TextWriter writer = new StreamWriter(path)) {
                XmlSerializer serializer = new XmlSerializer(typeof(PersistentDataset));
                serializer.Serialize(writer, this);
            }
        }
    }
}
