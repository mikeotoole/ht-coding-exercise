json.request do
  json.total_count @total_count if @total_count
  json.total_pages @total_pages if @total_pages
  json.current_page @page if @page
end

json.data JSON.parse(yield)
