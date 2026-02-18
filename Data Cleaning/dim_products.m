let
    // Access the source folder and target the specific CSV file
    Source_Folder = Folder.Files("your_folder_path"),
    File_Content = Source_Folder{[Name="product_data.csv"]}[Content],

    // Import the CSV. We limit it to 4 columns to automatically drop the "Unnamed" empty columns
    Imported_CSV = Csv.Document(File_Content,[Delimiter=",", Columns=4, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    Promote_Headers = Table.PromoteHeaders(Imported_CSV, [PromoteAllScalars=true]),

    // Remove the trailing empty rows (Filtering out nulls in the Product Code)
    Remove_Empty_Rows = Table.SelectRows(Promote_Headers, each ([Product Code] <> null and [Product Code] <> "")),

    // Assign standardized data types for financial calculations
    Set_Data_Types = Table.TransformColumnTypes(Remove_Empty_Rows,{
        {"Product Code", type text}, 
        {"Biscuit Brand", type text}, 
        {"Cost", type number}, 
        {"Unit Price", type number}
    }),

    // Professionalize headers for report readiness
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"Biscuit Brand", "Product Name"},
        {"Cost", "Unit Cost"},
        {"Unit Price", "Unit Price"}
    })
in
    Renamed_Columns
